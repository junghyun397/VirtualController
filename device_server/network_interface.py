import socket
import threading
import time
from enum import Enum
from math import floor
from typing import Callable, Tuple

WIFI_PORT = 10204


class NetworkProtocol:
    PASS = 0
    VALIDATION = -2

    ANALOGUE_INPUT_COUNT = 8
    DIGITAL_INPUT_COUNT = 128

    DIGITAL_TRUE = 1
    DIGITAL_FALSE = 0


class PacketType(Enum):
    ERROR = 0
    VALIDATION = 1
    ANALOGUE = 2
    DIGITAL = 3


class ParsedPacket:

    def __init__(self, decoded_data: str):
        splitted_data = decoded_data.split(":")
        if len(splitted_data) != 2:
            self.packet_type = PacketType.ERROR
            return

        self.target_input = int(splitted_data[0])
        self.body = splitted_data[1]

        if self.target_input == NetworkProtocol.VALIDATION:
            self.packet_type = PacketType.VALIDATION
        elif self.target_input <= NetworkProtocol.ANALOGUE_INPUT_COUNT:
            self.packet_type = PacketType.ANALOGUE
        elif self.target_input <= NetworkProtocol.DIGITAL_INPUT_COUNT:
            self.packet_type = PacketType.DIGITAL
        else:
            self.packet_type = PacketType.ERROR

    def __str__(self):
        return "type: " + str(self.packet_type) \
               + " target-input: " + str(self.target_input) \
               + " data: " + str(self.body)


class SocketListener:

    def __init__(self,
                 on_packet_receive: Callable[[ParsedPacket], None],
                 use_recover_socket: bool = False,
                 message_listener: Callable[[str], None] = lambda s: print(s),
                 state_listener: Callable[[Tuple[bool, str]], None] = lambda _: None,
                 ):
        self._on_packet_receive = on_packet_receive
        self._use_recover_socket = use_recover_socket
        self._message_listener = message_listener
        self._state_listener = state_listener

        self._thread = None

        self._server_socket = None
        self._server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self._server_socket.bind(("", WIFI_PORT))

    def start_socket(self):
        self._thread = threading.Thread(target=self._run_socket)
        self._thread.start()

    def kill_socket(self):
        self._server_socket.close()
        self._thread.join()

        if self._use_recover_socket:
            self._message_listener("[!] an error occurred. recover server socket...")
            self._run_socket()

    def _run_socket(self):
        self._message_listener("[*] start opening VFT-device-server socket...")

        self._server_socket.listen(5)

        self._message_listener("[o] succeed opening server-socket; listen at: " + str(WIFI_PORT))

        while True:
            client_socket, address = self._server_socket.accept()
            self._message_listener("[+] connection by: " + str(address))

            prv_validation_time = 0
            while True:
                try:
                    data = client_socket.recv(1024).decode()
                except ConnectionResetError as error:
                    self._message_listener("[!] handle error: " + str(error))
                    self.kill_socket()
                    return

                if data == "":
                    self._message_listener("[-] disconnected by: " + str(address))
                    self._state_listener((False, ""))  # disconnected
                    break

                packets = data.split("d")[1:]
                if len(packets) == 0:
                    self._message_listener("[x] failed parse packet chunk; raw: " + str(data))
                    continue

                for m_packet in packets:
                    packet = ParsedPacket(m_packet)
                    if packet.packet_type == PacketType.ERROR:
                        self._message_listener("[x] failed parse packet; raw: " + str(data))
                        continue
                    else:
                        self._message_listener("[<] receive data; " + str(packet))

                    if packet.packet_type == PacketType.VALIDATION:
                        self._state_listener((True, packet.body.split("/")[0]))  # connected

                        validation_time = int(packet.body.split("/")[1])
                        response = [str(NetworkProtocol.VALIDATION), ":",
                                    socket.gethostname(), "/", str(floor(time.time()))]
                        response = "".join(response)
                        self._message_listener("[>] send validation response; delay: "
                                               + str(floor((validation_time - prv_validation_time) / 1000))
                                               + "ms")

                        prv_validation_time = validation_time

                        client_socket.send(response.encode())
                    else:
                        self._on_packet_receive(ParsedPacket(m_packet))

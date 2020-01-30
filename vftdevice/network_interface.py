import socket
import threading
from enum import Enum
from math import floor
from typing import Callable

PORT = 42424


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

    def __init__(self, on_packet_receive: Callable[[ParsedPacket], None]):
        self._on_packet_receive = on_packet_receive
        self._thread = None

        self._server_socket = None
        self._server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self._server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self._server_socket.bind(("", PORT))

    def start_socket(self):
        self._thread = threading.Thread(target=self._run_socket)
        self._thread.start()

    def kill_socket(self):
        self._thread.join()

    def _run_socket(self):
        print("[*] start opening VFT-device-server socket...")

        self._server_socket.listen(5)

        print("[o] succeed opening server-socket; listen at:", PORT)

        while True:
            client_socket, address = self._server_socket.accept()
            print("[+] connection by:", address)

            prv_validation_time = 0
            while True:
                data = client_socket.recv(1024).decode()
                if data == "":
                    print("[-] disconnected by:", address)
                    break

                packets = data.split("d")[1:]
                if len(packets) == 0:
                    print("[x] failed parse packet chunk; raw:", data)
                    continue

                for m_packet in packets:
                    packet = ParsedPacket(m_packet)
                    if packet.packet_type == PacketType.ERROR:
                        print("[x] failed parse packet; raw:", data)
                        continue
                    else:
                        print("[<] receive data;", str(packet))

                    if packet.packet_type == PacketType.VALIDATION:
                        validation_time = int(packet.body.split("/")[1])
                        response = socket.gethostname() + "/" + str(0 if prv_validation_time == 0
                                                                    else validation_time - prv_validation_time)

                        print("[>] send validation response; delay:",
                              floor((validation_time - prv_validation_time) / 1000), "ms")

                        prv_validation_time = validation_time

                        client_socket.send(response.encode())
                    else:
                        self._on_packet_receive(ParsedPacket(m_packet))

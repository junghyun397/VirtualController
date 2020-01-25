import socket
from enum import Enum

PORT = 42424


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
        self.body = int(splitted_data[1])

        if self.target_input == -2:
            self.packet_type = PacketType.VALIDATION
        elif self.target_input < 10:
            self.packet_type = PacketType.ANALOGUE
        else:
            self.packet_type = PacketType.DIGITAL

    def __str__(self):
        return "type: " + str(packet.packet_type) \
               + " target-input: " + str(packet.target_input) \
               + " data: " + str(packet.body)


server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(("", PORT))
server_socket.listen(5)

print("[o] listen at:", PORT)

while True:
    client_socket, address = server_socket.accept()
    print("[+] connection by:", address)

    while True:
        data = client_socket.recv(1024).decode()
        if data == "":
            print("[-] disconnected by:", address)
            break

        packets = data.split("d")[1:]
        if len(packets) == 0:
            print("[x] failed parse packets; raw:", data)
            continue

        for m_packet in packets:
            packet = ParsedPacket(m_packet)

            if packet.packet_type == PacketType.ERROR:
                print("[x] failed parse packet; raw:", data)
                continue
            else:
                print("[<] receive data;", str(packet))

            if packet.packet_type == PacketType.VALIDATION:
                response = "alive"
                print("[>] send validation response: ", response)
                client_socket.send(response.encode())

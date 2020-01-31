import pyvjoy

from vftdevice.network_interface import SocketListener, ParsedPacket, PacketType


def on_packet_receive(packet: ParsedPacket) -> None:
    if packet.packet_type == PacketType.ANALOGUE:
        joystick.set_axis(packet.target_input - 1 + 0x30, int(int(packet.body) / 1000 * 32768))
    if packet.packet_type == PacketType.DIGITAL:
        joystick.set_button(packet.target_input - 1 - 7, int(packet.body))

if __name__ == '__main__':
    print("[*] start loading vjoy device...")

    joystick = pyvjoy.VJoyDevice(1)

    joystick.reset()
    joystick.reset_buttons()
    joystick.reset_povs()

    print("[o] succeed loading vjoy device.")

    socket = SocketListener(on_packet_receive=on_packet_receive)

    socket.start_socket()

    while True:
        command = input()
        if command.lower() == "stop":
            socket.kill_socket()
            print("[i] shutdown server...")

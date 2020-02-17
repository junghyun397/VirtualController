import pyvjoy

from . import network_interface


def on_packet_receive(packet: network_interface.ParsedPacket) -> None:
    if packet.packet_type == network_interface.PacketType.ANALOGUE:
        joystick.set_axis(packet.target_input - 1 + 0x30, int(int(packet.body) / 1000 * 32768))
    if packet.packet_type == network_interface.PacketType.DIGITAL:
        joystick.set_button(packet.target_input - 1 - 7, int(packet.body))

if __name__ == '__main__':
    print("[*] start loading vjoy device...")

    joystick = pyvjoy.VJoyDevice(1)

    joystick.reset()
    joystick.reset_buttons()
    joystick.reset_povs()

    print("[o] succeed loading vjoy device.")

    socket = network_interface.SocketListener(on_packet_receive=on_packet_receive, use_recover_socket=True)
    socket.start_socket()

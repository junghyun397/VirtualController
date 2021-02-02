# noinspection PyUnresolvedReferences
import pyvjoy

from device_server import tk_graphic_interface
from device_server.network_interface import SocketListener, ParsedPacket, PacketType


def on_packet_receive(packet: ParsedPacket) -> None:
    if packet.packet_type == PacketType.ANALOGUE:
        joystick.set_axis(packet.target_input - 1 + 0x30, int(int(packet.body) / 1000 * 32768))
    if packet.packet_type == PacketType.DIGITAL:
        joystick.set_button(packet.target_input - 1 - 7, int(packet.body))


if __name__ == '__main__':
    gui = tk_graphic_interface.TkGraphicInterface(on_stop=lambda _: exit())
    gui.start_ui()

    gui.on_emit_log("[*] start loading vjoy device...")

    joystick = pyvjoy.VJoyDevice(1)

    joystick.reset()
    joystick.reset_buttons()
    joystick.reset_povs()

    gui.on_emit_log("[o] succeed loading vjoy device.")

    socket = SocketListener(on_packet_receive=on_packet_receive,
                            use_recover_socket=True,
                            message_listener=gui.on_emit_log,
                            state_listener=gui.on_update_status,
                            )
    socket.start_socket()

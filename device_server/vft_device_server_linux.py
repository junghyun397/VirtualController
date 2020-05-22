from device_server import network_interface
from device_server import tk_graphic_interface

if __name__ == '__main__':
    print("[!] warning! VFT-device-server for linux is write for debugging. "
          "linux version has no functionality other than to receive packets.")

    gui = tk_graphic_interface.TkGraphicInterface(on_stop=lambda _: exit())
    gui.start_ui()

    socket = network_interface.SocketListener(on_packet_receive=lambda _: None,
                                              use_recover_socket=True,
                                              message_listener=gui.on_emit_log,
                                              state_listener=gui.on_update_status,
                                              )
    socket.start_socket()


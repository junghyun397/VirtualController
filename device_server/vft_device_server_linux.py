from . import network_interface

if __name__ == '__main__':
    print("[!] warning! VFT-device-server for linux is write for debugging. "
          "linux version has no functionality other than to receive packets.")

    socket = network_interface.SocketListener(on_packet_receive=lambda _: None, use_recover_socket=True)
    socket.start_socket()

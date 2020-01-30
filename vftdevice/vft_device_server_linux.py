from vftdevice.network_interface import SocketListener

if __name__ == '__main__':
    print("[!] warning! VFT-device-server for linux is written for debugging. "
          "linux version has no functionality other than to receive packets.")

    socket = SocketListener(on_packet_receive=lambda _: None)

    socket.start_socket()
    # print("[!] an error occurred. re-create server socket ....")

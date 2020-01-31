from vftdevice.network_interface import SocketListener

if __name__ == '__main__':
    print("[!] warning! VFT-device-server for linux is write for debugging. "
          "linux version has no functionality other than to receive packets.")

    socket = SocketListener(on_packet_receive=lambda _: None)

    socket.start_socket()

    while True:
        command = input(">>")
        print(command)
        if command.lower() == "stop":
            socket.kill_socket()
            print("[i] shutdown server...")

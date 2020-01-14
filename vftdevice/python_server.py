import socket

PORT = 42424

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(("", PORT))
server_socket.listen(5)

print("[o] listen at:", PORT)

while True:
	client_socket, address = server_socket.accept()
	print ("[+] connection by:", address)

	while True:
		data = client_socket.recv(1024).decode()
		if data == "":
		    print("[-] disconnected by:", address)
		    break    
		print ("[ ] receive data:" , data)

server_socket.close()
print("[x] end.")
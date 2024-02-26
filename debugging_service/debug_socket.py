import socket
import threading


class Client:
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.socket.connect((self.host, self.port))
        threading.Thread(target=self.receive_messages, daemon=True).start()

    def send_message(self, message):
        self.socket.sendall(message.encode())

    def receive_messages(self):
        while True:
            data = self.socket.recv(1024)
            if data:
                print(f"Received: {data.decode()}")


def main():
    server_host = "localhost"
    server_port = 12345

    client1 = Client(server_host, server_port)
    client2 = Client(server_host, server_port)

    # Send messages from clients
    client1.send_message("Hello from Client 1!")
    client2.send_message("Hello from Client 2!")

    # Keep the script running
    input("Press Enter to exit...\n")


if __name__ == "__main__":
    main()

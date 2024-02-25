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


def listen_udp(host, port):
    # Create a UDP socket
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
        # Bind the socket to the host and port
        s.bind((host, port))
        print(f"Listening for UDP packets on {host}:{port}...")
        while True:
            # Receive data from the socket
            data, addr = s.recvfrom(1024)
            print(f"Received UDP packet from {addr}: {data.decode()}")


def main():
    # Start the UDP listener
    udp_host = "0.0.0.0"
    udp_port = 8090
    listen_udp(udp_host, udp_port)

    # server_host = "localhost"
    # server_port = 12345

    # client1 = Client(server_host, server_port)
    # client2 = Client(server_host, server_port)

    # # Send messages from clients
    # client1.send_message("Hello from Client 1!")
    # client2.send_message("Hello from Client 2!")

    # # Keep the script running
    # input("Press Enter to exit...\n")


if __name__ == "__main__":
    main()

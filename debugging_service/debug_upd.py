import socket


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
    udp_host = "localhost"
    udp_port = 8090
    listen_udp(udp_host, udp_port)


if __name__ == "__main__":
    main()

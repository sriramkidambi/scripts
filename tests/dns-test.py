import dns.resolver
import time
import sys


DNS_SERVERS = {
    "Google Public DNS": ["8.8.8.8", "8.8.4.4"],
    "Cloudflare": ["1.1.1.1", "1.0.0.1"],
    "Quad9 (Filtered, Anycast)": ["9.9.9.9"],
    "OpenDNS Home": ["208.67.222.222", "208.67.220.220"],
    "AdGuard DNS (Default)": ["94.140.14.14", "94.140.15.15"], # [2]
    "CleanBrowsing (Filter Adult)": ["185.228.168.9", "185.228.169.9"], # [2]
}

TEST_DOMAIN = "www.google.com"

def test_dns_server(server_ip, domain):
    """Tests a single DNS server and returns the query time in milliseconds."""
    resolver = dns.resolver.Resolver()
    resolver.nameservers = [server_ip]
    resolver.timeout = 5 # Set a timeout for queries
    resolver.lifetime = 5

    try:
        start_time = time.time()
        # Perform an A record query
        resolver.resolve(domain, 'A')
        end_time = time.time()
        return (end_time - start_time) * 1000 # Return time in milliseconds
    except dns.exception.Timeout:
        return float('inf') # Indicate timeout
    except Exception as e:
        print(f"Error querying {server_ip}: {e}", file=sys.stderr)
        return float('inf') # Indicate other errors

def main():
    results = {}
    print(f"Testing DNS server speeds by querying '{TEST_DOMAIN}'...\n")

    for server_name, ip_addresses in DNS_SERVERS.items():
        min_time = float('inf')
        fastest_ip = None
        print(f"Testing {server_name}...")

        for ip in ip_addresses:
            print(f"  Testing IP: {ip}...")
            query_time = test_dns_server(ip, TEST_DOMAIN)

            if query_time == float('inf'):
                print(f"    Timeout or error.")
            else:
                print(f"    Time: {query_time:.2f} ms")

            if query_time < min_time:
                min_time = query_time
                fastest_ip = ip

        results[server_name] = {"time": min_time, "ip": fastest_ip}
        print("-" * 20)

    print("\n--- Results ---")
    # Sort results by time
    sorted_results = sorted(results.items(), key=lambda item: item[1]['time'])

    # Print results in a formatted table
    print(f"{'Server Name':<30} | {'IP Address':<15} | {'Avg Time (ms)':<15}")
    print("-" * 65)
    for server_name, data in sorted_results:
        time_str = f"{data['time']:.2f}" if data['time'] != float('inf') else "Timeout/Error"
        print(f"{server_name:<30} | {data['ip']:<15} | {time_str:<15}")

    print("\n--- Conclusion ---")
    if sorted_results[0][1]['time'] != float('inf'):
        fastest_server_name = sorted_results[0][0]
        fastest_server_ip = sorted_results[0][1]['ip']
        fastest_time = sorted_results[0][1]['time']
        print(f"The fastest DNS server found is {fastest_server_name} ({fastest_server_ip}) with an average time of {fastest_time:.2f} ms.")
    else:
        print("Could not determine a fastest server (all timed out or had errors).")

if __name__ == "__main__":
    main()

import subprocess
import os
import signal
import sys

def start_process(name, command, cwd):
    print(f"\n🚀 Starting {name} in {cwd}")
    process = subprocess.Popen(
        command,
        cwd=cwd,
        shell=True,
        stdout=None,  # Let output go to terminal
        stderr=None
    )
    print(f"✅ {name} started with PID {process.pid}")
    return process

def main():
    base = os.path.abspath(os.path.dirname(__file__))
    processes = []

    services = [
        ("User Service", "uvicorn main:app --host 0.0.0.0 --port 8010", f"{base}/services/user-service"),
        ("ML Model Service", "uvicorn main:app --host 0.0.0.0 --port 9000", f"{base}/services/ml-model-service"),
        ("API Gateway", "uvicorn main:app --host 0.0.0.0 --port 8000", f"{base}/services/api-gateway"),
        ("Transaction Simulator", "python producer.py", f"{base}/services/transaction-service"),
        ("Notification Service", "python consumer.py", f"{base}/services/notification-service"),
    ]

    try:
        for name, cmd, path in services:
            proc = start_process(name, cmd, path)
            processes.append((name, proc))

        print("\n🟢 All services are running. Press Ctrl+C to stop everything.")
        while True:
            pass  # Keep main thread alive

    except KeyboardInterrupt:
        print("\n🛑 Ctrl+C detected! Shutting down all services...")
        for name, proc in processes:
            print(f"🔻 Terminating {name} (PID {proc.pid})")
            proc.terminate()
        print("✅ All services terminated.")
        sys.exit(0)

if __name__ == '__main__':
    main()


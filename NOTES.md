# NOTES

- run.py
    - starts code coverage
    - start run_tool.py
        - start run_service.py
            - start main.py

- the MITM proxy logs requests and responses
- the service is started at a specific port in the 50000 range. The proxy works on the 30000 range and proxies to the service on its 50000 port
- the tool interacts with the 30000 port
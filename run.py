import sys
import time
import subprocess
import os
import shutil
import glob

time_limit = os.getenv('TIME_LIMIT')
assert time_limit is not None
print(f"Time limit: {time_limit}m")

if __name__ == "__main__":
    tool = sys.argv[1]

    num_iterations = int(os.getenv("NUM_ITERATIONS", 5))

    base_cov_port = 11000
    services = ["features-service", "languagetool", "ncs", "restcountries", "scs", "genome-nexus", "person-controller", "user-management", "market", "project-tracking-system"]
    service_to_run = os.getenv("SERVICES")

    if not os.path.exists('runs'):
        os.makedirs('runs')

    for j in range(num_iterations):
        dir = f"runs/{j}"
        if not os.path.exists(dir):
            os.makedirs(dir)
            
        for i, name in enumerate(services):
            # hack so the filenames line up (i.e. 11000_1)
            if service_to_run != name:
                continue
            cov_port = base_cov_port + i*10
            print("Running " + tool + " for " + services[i] + ": " + str(cov_port))
            session = tool + '_' + services[i]
            cov_session = services[i] + "_cov"
            print(f"Starting tmux sessions: {cov_session} and {session}")
            subprocess.run("tmux new -d -s " + cov_session + " sh get_cov.sh " + str(cov_port) + " " + dir, shell=True)
            subprocess.run("tmux new -d -s " + session + " 'timeout " + time_limit + "h python3 run_tool.py " + tool + ' ' + services[i] + ' ' + str(cov_port) + "'", shell=True)

        time.sleep(int(time_limit) * 60) # wait for it to run for the timeout period
        print("Run done, waiting for files to finish writing and to dump code coverage results")
        time.sleep(120) # wait for the proxy to finish exporting it's values and for code coverage to be dumped
        print("Done")

        print("Stop running services...")
        subprocess.run("docker stop `docker ps -a -q`", shell=True)
        time.sleep(30)
        subprocess.run("docker rm `docker ps -a -q`", shell=True)
        print("Cleaning up any remaining tmux sessions")
        for i, name in enumerate(services):
            if service_to_run != name:
                continue
            subprocess.run("tmux kill-sess -t " + services[i], shell=True)
            subprocess.run("tmux kill-sess -t " + services[i] + "_cov", shell=True)
            subprocess.run("tmux kill-sess -t " + services[i] + "_proxy", shell=True)
            subprocess.run("tmux kill-sess -t " + tool + '_' + services[i], shell=True)

        files = glob.glob('*.txt')
        for file in files:
            if file != 'requirements.txt':
                shutil.move(file, dir)

        files = glob.glob('*.json')
        for file in files:
            if not file.startswith('package'):
                shutil.move(file, dir)

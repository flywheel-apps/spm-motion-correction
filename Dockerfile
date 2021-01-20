# Create Docker container that can run spm_motion_correction analysis.

# Start with the Matlab runtime container
FROM flywheel/matlab-mcr:v97

MAINTAINER Michael Perry

# ADD the Matlab Stand-Alone (MSA) into the container
COPY src/bin/* /usr/local/bin/

# Ensure that the executable files are executable
RUN chmod +x /usr/local/bin/*

# Copy and configure run script and metadata code
COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
ENTRYPOINT ["/usr/local/bin/run_spm_motion_correction.sh"]

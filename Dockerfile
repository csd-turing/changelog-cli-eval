FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    build-essential \
    curl \
    iptables \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install pytest pyyaml packaging --break-system-packages

RUN git config --global user.email "test@example.com" && \
    git config --global user.name "Test User"

# ---------------------------------------------------------------------------
# Clone the eval repo — all setup scripts and the pre-compiled test .pyc
# are pulled from GitHub in one step
# ---------------------------------------------------------------------------
RUN git clone https://github.com/csd-turing/changelog-cli-eval.git /repo

RUN mkdir -p /workspace/cli /workspace/tests /workspace/testrepo /setup

RUN cp /repo/setup/init_testrepo.sh /setup/init_testrepo.sh && \
    cp /repo/setup/init_tests.sh    /setup/init_tests.sh    && \
    cp /repo/setup/test_changelog.pyc /setup/test_changelog.pyc && \
    cp /repo/entrypoint.sh /entrypoint.sh && \
    chmod +x /setup/init_testrepo.sh /setup/init_tests.sh /entrypoint.sh

RUN bash /setup/init_testrepo.sh
RUN bash /setup/init_tests.sh

RUN curl -fsSL https://opencode.ai/install | bash && \
    cat /root/.opencode/install.log || true
ENV PATH="/root/.opencode/bin:${PATH}"

WORKDIR /workspace/cli
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]

FROM rockylinux:9

LABEL maintainer="Adam Leff" \
      description="Personal dev toolbox — Rocky 9, bash, AWS CLI, Python" \
      version="0.1.0"

# ── System packages ────────────────────────────────────────────────────────────
# Single RUN layer: keeps the layer count low and cache efficient.
# Order: update → install → clean.  Never split dnf update from install.
RUN dnf update -y && \
    dnf install -y \
        bash \
        git \
        curl \
        wget \
        rsync \
        tree \
        htop \
        vim \
        jq \
        python3 \
        python3-pip \
        unzip \
        less \
        man-db \
        shellcheck && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# ── yq (GitHub release — not in Rocky repos) ──────────────────────────────────
# Pull the correct arch binary so this works on both amd64 and arm64.
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then YQ_ARCH="arm64"; else YQ_ARCH="amd64"; fi && \
    curl -fsSL \
      "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${YQ_ARCH}" \
      -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# ── AWS CLI v2 ─────────────────────────────────────────────────────────────────
RUN ARCH=$(uname -m) && \
    curl -fsSL \
      "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" \
      -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

# ── Python packages ────────────────────────────────────────────────────────────
RUN pip3 install --no-cache-dir \
    boto3 \
    requests \
    paramiko

# ── Dotfiles ───────────────────────────────────────────────────────────────────
# COPY at the end so dotfile edits don't bust the package cache layers above.
COPY dotfiles/.bashrc      /root/.bashrc
COPY dotfiles/.gitconfig   /root/.gitconfig
COPY dotfiles/.ssh_config  /root/.ssh/config

RUN chmod 600 /root/.ssh/config

# ── Scripts directory (populated at runtime via bind mount or git clone) ───────
RUN mkdir -p /root/scripts
WORKDIR /root

# ── Entrypoint ─────────────────────────────────────────────────────────────────
# docker-entrypoint.sh: optionally git-clones the scripts repo before dropping
# into bash.  See docker-entrypoint.sh below.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
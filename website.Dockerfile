# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.12.10
FROM python:${PYTHON_VERSION}-slim AS base

# Download and install uv
COPY --from=ghcr.io/astral-sh/uv:0.7.8 /uv /uvx /bin/

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Ensure uv is on PATH
# ENV PATH="/root/.local/bin/:$PATH"

WORKDIR /app

# Enable bytecode compilation
ENV UV_COMPILE_BYTECODE=1

# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

# Create a non-privileged user with /app as home
RUN adduser --disabled-password --gecos "" --home /app --shell /sbin/nologin appuser

# Install the project's dependencies using the lockfile and settings
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --locked --no-install-project --no-dev

# Then, add the rest of the project source code and install it
# Installing separately from its dependencies allows optimal layer caching
COPY . /app

# Change ownership of /app to appuser
RUN chown -R appuser:appuser /app

# Switch to non-privileged user
USER appuser

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"

# Expose the port that the application listens on.
EXPOSE 8080

# Build argument to determine environment
ARG FLASK_ENV=development
ENV FLASK_ENV=${FLASK_ENV}

# Use shell form CMD to switch between development and production
CMD if [ "$FLASK_ENV" = "production" ]; then \
    gunicorn --bind 0.0.0.0:8080 --workers 4 --access-logfile - main:app; \
    else \
    uv run main.py; \
    fi

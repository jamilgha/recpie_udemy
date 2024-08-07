
# Use an official Python runtime as a parent image
FROM python:3.9-alpine3.13

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Set working directory
WORKDIR /app
COPY req.txt /app/
COPY req.dev.txt /app/
# Install dependencies
COPY ./req.txt /temp/req.txt
ARG DEV=false
RUN python3 -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /app/req.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /app/req.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user

# Add /py/bin to PATH to ensure our virtualenv is used
ENV PATH="/py/bin:$PATH"

# Copy the application code to the working directory
COPY . /app

# Change the ownership of the application files to django-user
RUN chown -R django-user /app

# Switch to the django-user
USER django-user

# Command to run the Django server (adjust as needed)
CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]

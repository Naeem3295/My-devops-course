# Class 1 - Introduction to DevOps
## Overview
This class covers the complete course curriculum and initial setup for DevOps engineering.

## Topics Covered
- Overview of the course curriculum
- On boarding people with Cloud and git repos
- Onboarding students to whatsapp, facebook and discord channels
- Running DevOps Demo application locally and exposing with ngrok

## What is ngrok?
ngrok is a tool that creates a secure tunnel from the internet to your local machine.
It allows you to expose a local web server to the internet without deploying it.

### How ngrok works:
- You run an app locally (example: on port 8080)
- ngrok creates a public URL like: https://abc123.ngrok.io
- Anyone on the internet can access your local app through that URL

### Why we use ngrok in DevOps:
- Testing webhooks locally
- Sharing local development work with team
- Demonstrating apps without deploying to server

## Goal
Setting up the project in local and expose it over ngrok and get response

## Hands-on Steps
1. Install ngrok from https://ngrok.com
2. Run your application locally
3. Run command: ngrok http 8080
4. Copy the public URL and share it

# Demonstrate your ability to script infrastructure and code deploys

### Requirements

You'll need [Vagrant](https://www.vagrantup.com/) and [Ansible](https://docs.ansible.com/ansible/intro_installation.html) for this exercise.


### The task(s)

Your submission will demonstrate:
* You can follow directions.
* You can pick up and modify existing code.
* You can create a basic Ansible playbook.
* Your attention to good security practices.
* You can do all of the above efficiently.

If you already have experience with Vagrant, Ansible, nginx, and runit this exercise should take under an hour.  If you do not, it will take 1-3 hours, depending on how much fun you are having with it.  Prior experience with those tools is not required.  If anything, it is more impressive if you are able to complete this exercise using Google and your own problem-solving abilities.


#### Part One

Complete the `config/nginx.conf` file according to the following requirements.

Requirements:

- Nginx should accept requests on ports 80 and 443.
- All `http` requests should permanently redirect to their `https` equivalent.
- Use the provided `files/self-signed.crt` and `files/self-signed.key` for your SSL configuration.
- Your SSL configuration should use modern, secure protocols and ciphers.
- Nginx should proxy requests to the application using an `upstream` directive.
- Pass headers `X-Forwarded-For` and `X-Real-IP` to the upstream application with appropriate values.


#### Part Two

Complete the Ansible `playbook.yml` file according to the following requirements for the remote system.

Requirements:

- Install nginx and runit.
- Copy your `config/nginx.conf`, `files/self-signed.key` and `files/self-signed.crt` to the appropriate directories.
- Install the contents of application.zip to `/opt/application/`.
- Install and configure that application's `run` script as a runit service.
- Start nginx.


### Putting it all together (and checking your work)

Your submitted solution will be verified using the included `./provision.sh`.  You should make use of it yourself, both to validate your solution and to better understand what we're expecting from your solution.

Be aware that `provision.sh` destroys and recreates the Vagrant box each time it is run.

A working configuration will render:

```
Pass: status code is 200
Pass: X-Forwarded-For is present and not 'None'
Pass: X-Real-IP is present and not 'None'
Pass: found "Learn from the mistakes of others. You can never live long enough to make them all yourself." in response
```


### Tips & Guidance:

- You can find a suitable runit package at: https://packagecloud.io/imeyer/runit
- Do not alter the `Vagrantfile`.
- Avoid chaining commands using `|` and `&&` in your `playbook.yml`.


### How to submit:

Compress your `provision` subdirectory (zip, tar, what have you) containing your solution and email it to: dfowlkes@geonorth.com

Do not include `.vagrant/`, `.retry` files, or other detritus in your submission.

Please include a README file inside the zip with any notes on running your solution, why you choose a particular solution, or anything else that you would like us to know.

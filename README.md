# Adhokku

A toy single-host PaaS powered by FreeBSD jails and managed with Ansible.

# How it works

When you deploy an application using Adhokku, Adhokku creates a new [jail](https://en.wikipedia.org/wiki/FreeBSD_jail) on the remote host and provisions it from a fixed clean state using the instructions in the `Jailfile` in your Git repository. (A `Jailfile` is a simple POSIX shell script; [here is one](https://github.com/adhokku/adhokku-caddy/blob/master/Jailfile).) All jails sit behind a reverse proxy that directs traffic to one of them based on the domain name or the IP address in the HTTP request. When a new jail has been provisioned for an application, Adhokku seemlessly reconfigures the reverse proxy to send traffic to it instead of the one currently active for that application.

Adhokku is built as an [Ansible](https://www.ansible.com/) role, so it operates over SSH and requires no specialized daemons running on the remote host for setup or deployment. 

# Requirements

Ansible 2.0 or later and Git installed on the developer machine. FreeBSD 10.3 or 11.0, -RELEASE or -STABLE, on the server (other versions may work but haven't been tested).

# Setup

The following instructions show how to get Adhokku and an example application running in a VM on your development machine using [Vagrant](https://www.vagrantup.com/). This process should require no FreeBSD-specific knowledge, though modifying the `Jailfile` to customize the application may.

If you are familiar with FreeBSD you can install Adhokku on a host of your choice. To do this, get the host to a point where it accepts SSH connections with your SSH key and lets you run commands as root via `sudo`. Then, follow the instructions with the appropriate modifications like skipping step 5.

Note that Adhokku expects a clean FreeBSD installation that isn't used for anything else and does not account for possible conflicts with other software.

1\. Install Adhokku using Ansible Galaxy and set the environment variable `ADHOKKU_PATH`.

```shell
sudo ansible-galaxy install adhokku.adhokku
export ADHOKKU_PATH="/etc/ansible/roles/adhokku.adhokku/"
```

2\. Create a new project, e.g., in `~/projects/adhokku-hello/`.

```shell
cd ~/projects/
mkdir adhokku-hello
cd adhokku-hello
git init
```

3\. Create the Ansible files needed to run Adhokku commands with `adhokku-tool`.

```shell
sh "$ADHOKKU_PATH/adhokku-tool" init
```

4\. Add a submodule for a `Jailfile`. Your project's `Jailfile` will import it.

```
git submodule add https://github.com/adhokku/adhokku-caddy
echo '/.vagrant' > .gitignore
echo '. /app/adhokku-caddy/Jailfile' > Jailfile
mkdir static
echo '<h1>Hello, world!</h1>' > static/index.html
git add .
git commit -m 'Initial commit'
```

5\. If you do not have a FreeBSD VM running Adhokku yet, create a new one with Vagrant.

```shell
cp "$ADHOKKU_PATH/Vagrantfile" .
vagrant up || vagrant up
```

6\. Set up Adhokku on the VM with Ansible.

```shell
ansible-playbook -i inventory playbooks/setup.yml
```

If you get an SSH error like "Failed to connect to the host via ssh." at this point, remove the key for other Vagrant VMs from your `~/.ssh/known_hosts` file with the commands

```shell
ssh-keygen -R '[127.0.0.1]:2222' -f ~/.ssh/known_hosts
ssh-keygen -R '[localhost]:2222' -f ~/.ssh/known_hosts
```

6\. Deploy the application.

```shell
ansible-playbook -i inventory playbooks/deploy.yml
```

7\. Browse to <http://127.0.0.1:8080/>.

# See also

* [Dokku](https://github.com/dokku/dokku) — The primary inspiration for this project. Dokku is a single-host open source PaaS for Linux powered by Docker.
* [ansible-elixir-stack](https://github.com/HashNuke/ansible-elixir-stack/) — The *other primary* inspiration. An Ansible role for running Elixir applications on Ubuntu. It gets the credit for the role action pattern and the idea behind `adhokku-tool`.
* [FreeBSD & LFE Images: Docker-like functionality with ezjail](http://blog.lfe.io/tutorials/2015/07/08/1416-freebsd--lfe-images-docker-like-functionality-with-ezjail/)

# License

Two-clause BSD.

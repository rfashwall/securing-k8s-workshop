- Add a new falco rule

```bash
cd /etc/falco/

cp falco_rules.yaml falco_rules.local.yaml

vim falco_rules.local.yaml
```{{exec}}

- Add the following rule at the end of the file

```
- rule: Terminal shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal.
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    NDC Attendies!!! (user_id=%user.uid repo=%container.image.repository %user.uiduser=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: NOTICE
  tags: [container, shell, mitre_execution]
```{{copy}}

- Restart falco
```bash
systemctl restart falco
```{{exec}}

- Access pod shell
```
k exec -it pod -- sh # run "exit"
```{{exec}}

- Open a new terminal and run the following command

```bash
cat /var/log/syslog | grep falco | grep NDC
```{{exec}}

c = get_config()  #noqa

c.ServerApp.allow_remote_access = True
c.ServerApp.ip = '*'
c.ServerApp.port = 8888

c.PasswordIdentityProvider.hashed_password = (
#### PLEASE CHANGE THIS TO YOUR ID/PW ###
)

c.ServerApp.open_browser = False
c.ServerApp.quit_button = False

c.ServerApp.terminado_settings = { "shell_command": ["/bin/bash"] }

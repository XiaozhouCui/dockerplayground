## Interactive Mode

- When terminal input is needed, `docker run CONTAINER` will show error   
- To enter input into container, need to use `docker run -it CONTAINER` to start interactive mode and a terminal
- When using `docker start CONTAINER` to re-start a container, `-a` can attach, but cannot enter value.
- Use `docker start -a -i CONTAINER` to interact with container.
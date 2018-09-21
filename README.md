# stacktraceutils

## Examples
```
# parse all exceptions from log files (gz also allowed) and extract an
# example each in the output directory (out)
./parse-exceptions.sh /var/log/tomcat8/catalina* | ./extract-exception-examples.sh -
```

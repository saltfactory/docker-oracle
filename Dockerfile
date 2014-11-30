FROM saltfactory/oraclelinux:7.0
MAINTAINER SungKwang Song <saltfactory@gmail.com>

RUN yum update -y
RUN yum install -y glibc make binutils gcc libaio bc net-tools
#RUN yum clean all

ADD Disk1 /Disk1

RUN yum localinstall -y /Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm
RUN rm -rf /Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm

#RUN sed -e '/memory_target/ s/^/pga_aggregate_target=200540160\nsga_target=601620480\n#/' -i /u01/app/oracle/product/11.2.0/xe/config/scripts/init.ora
#RUN sed -e '/memory_target/ s/^/pga_aggregate_target=200540160\nsga_target=601620480\n#/' -i /u01/app/oracle/product/11.2.0/xe/config/scripts/initXETemp.ora

RUN mv /Disk1/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/init.ora
RUN mv /Disk1/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/initXETemp.ora

RUN /etc/init.d/oracle-xe configure responseFile=/Disk1/response/xe.rsp

RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/profile.d/oracle_profile.sh
RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/profile.d/oracle_profile.sh
RUN echo 'export ORACLE_SID=XE' >> /etc/profile.d/oracle_profile.sh

# Create ssh keys and change some ssh settings
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

# Change the root and oracle password to oracle
RUN echo root:oracle | chpasswd
RUN echo oracle:oracle | chpasswd

VOLUME ['/data']

# Expose ports 22, 1521 and 8080
EXPOSE 22
EXPOSE 1521
EXPOSE 8080

# Change the hostname in the listener.ora file, start Oracle XE and the ssh daemon
CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora; \
service oracle-xe start; \
/usr/sbin/sshd -D

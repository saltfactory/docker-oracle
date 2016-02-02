FROM oraclelinux:7.2
MAINTAINER SungKwang Song <saltfactory@gmail.com>

RUN yum update -y
RUN yum install -y glibc make binutils gcc libaio bc net-tools unzip

ADD ./oracle-xe-11.2.0-1.0.x86_64.rpm.zip /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
RUN cd /tmp; unzip -d /tmp /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm.zip
RUN yum localinstall -y /tmp/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm
RUN rm -rf /tmp/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm

ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID=XE
ENV PATH $ORACLE_HOME/bin:$PATH

ADD ./assets/init.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/init.ora
ADD ./assets/initXETemp.ora /u01/app/oracle/product/11.2.0/xe/config/scripts/initXETemp.ora
ADD ./assets/xe.rsp /tmp/Disk1/response/xe.rsp
ADD ./assets/start.sh /tmp/start.sh 

RUN chmod +x /tmp/start.sh
RUN /etc/init.d/oracle-xe configure responseFile=/tmp/Disk1/response/xe.rsp

RUN echo root:oracle | chpasswd
RUN echo oracle:oracle | chpasswd

#VOLUME ['/data']

EXPOSE 22
EXPOSE 1521
EXPOSE 8080

CMD ["/tmp/start.sh"]


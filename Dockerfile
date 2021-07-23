FROM fedora:25

ENV PATH=/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin

RUN dnf install --assumeyes \
  bash \
  cairo-devel \
  cairo-gobject \
  cmake \
  dbus-devel \
  dbus-x11 \
  gcc \
  gdk-pixbuf2-devel \
  git \
  glib-devel \
  ImageMagick-devel \
  libxdg-basedir-devel \
  libxkbcommon-devel \
  libxkbcommon-x11-devel \
  lua-devel \
  lua-lgi \
  make \
  psmisc \
  rpm-build \
  shadow-utils \
  startup-notification-devel \
  xcb-util-cursor-devel \
  xcb-util-devel \
  xcb-util-keysyms-devel \
  xcb-util-wm-devel \
  xcb-util-xrm-devel

# sometimes DNF hangs
RUN killall --wait --quiet dnf || true 

RUN echo 'export PS1="[\u@foo/awesome:dom0] \w $ "' >> /etc/profile.d/env.sh

# awesome
RUN git clone https://github.com/awesomeWM/awesome /awesome
WORKDIR /awesome
RUN make package
RUN dnf install --assumeyes build/*.rpm

# user
RUN groupadd --gid 1000 limited
RUN useradd --shell /bin/bash --create-home --uid 1000 --gid 1000 limited
ENV HOME=/home/limited

# tini (unavailable in Fedora 25)
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

# dbus
RUN dbus-uuidgen > /var/lib/dbus/machine-id
RUN mkdir /var/run/dbus
RUN chown limited:limited /var/run/dbus

RUN dnf clean all

# finally
ENTRYPOINT [ "tini", "-s", "--" ]
USER limited
CMD [ "awesome" ]

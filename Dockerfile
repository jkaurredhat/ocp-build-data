# This is a base image for supporting running nodejs to build an app (console does this).
# The same Dockerfile should serve for most versions of nodejs.
FROM ubi8/nodejs-12:1-45

# Start Konflux-specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/ || true
COPY .oit/unsigned.repo /etc/yum.repos.d/
ADD https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem /tmp
# End Konflux-specific steps
ENV __doozer=update BUILD_RELEASE=202501072046.p0.g0fb79a4.assembly.stream.el8 BUILD_VERSION=v4.6.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=6 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.6.0-202501072046.p0.g0fb79a4.assembly.stream.el8 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.6 __doozer_key=openshift-base-nodejs __doozer_uuid_tag=base-nodejs-v4.6.0-20250107.204624 __doozer_version=v4.6.0 
ENV __doozer=merge OS_GIT_COMMIT=0fb79a4 OS_GIT_VERSION=4.6.0-202501072046.p0.g0fb79a4.assembly.stream.el8-0fb79a4 SOURCE_DATE_EPOCH=1628716494 SOURCE_GIT_COMMIT=0fb79a4bfdfad72416f37f6a10e672d05b52ba9e SOURCE_GIT_TAG=0fb79a4b SOURCE_GIT_URL=https://github.com/openshift-eng/ocp-build-data 
# rhel-7 based:
#   rhscl/nodejs-8-rhel7 from rh-nodejs8-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=67373)
#   rhscl/nodejs-12-rhel7 from rh-nodejs12-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=72290)
# rhel-8 based:
#   ubi8/nodejs-12 from nodejs-12-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=72249)
#   ubi8/nodejs-14 from nodejs-14-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=74670)
#
# rhel-8 repos include potential updates to nodejs patch version, but we must
# lock the version to match the headers tarball required for compilation, so we
# exclude upgrades for nodejs below.

USER root
RUN echo 'skip_missing_names_on_install=0' >> /etc/yum.conf \
 && echo 'exclude=nodejs nodejs-docs nodejs-full-i18n npm' >> /etc/yum.conf \
 && yum update -y  \
 && yum clean all
USER 1001

# Start Konflux-specific steps
RUN cp /tmp/yum_temp/* /etc/yum.repos.d/ || true
# End Konflux-specific steps

LABEL \
        io.k8s.description="This image is only used in building the console image and not as a base for anything shipped." \
        name="openshift/base-nodejs" \
        com.redhat.component="openshift-base-nodejs-container" \
        io.openshift.maintainer.project="OCPBUGS" \
        io.openshift.maintainer.component="Release" \
        version="v4.6.0" \
        release="202501072046.p0.g0fb79a4.assembly.stream.el8" \
        io.openshift.build.commit.id="0fb79a4bfdfad72416f37f6a10e672d05b52ba9e" \
        io.openshift.build.source-location="https://github.com/openshift-eng/ocp-build-data" \
        io.openshift.build.commit.url="https://github.com/openshift-eng/ocp-build-data/commit/0fb79a4bfdfad72416f37f6a10e672d05b52ba9e" \
        io.k8s.display-name="" \
        io.openshift.tags="" \
        description="" \
        summary=""


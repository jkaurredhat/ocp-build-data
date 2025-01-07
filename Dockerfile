# This is a base image that most rhel8-based containers should layer on.
FROM brew.registry.redhat.io/rh-osbs/rhel-els:8.2-23

# Start Konflux-specific steps
RUN mkdir -p /tmp/yum_temp; mv /etc/yum.repos.d/*.repo /tmp/yum_temp/ || true
COPY .oit/unsigned.repo /etc/yum.repos.d/
ADD https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem /tmp
# End Konflux-specific steps
ENV __doozer=update BUILD_RELEASE=202501072046.p0.gf020942.assembly.stream.el8 BUILD_VERSION=v4.6.0 OS_GIT_MAJOR=4 OS_GIT_MINOR=6 OS_GIT_PATCH=0 OS_GIT_TREE_STATE=clean OS_GIT_VERSION=4.6.0-202501072046.p0.gf020942.assembly.stream.el8 SOURCE_GIT_TREE_STATE=clean __doozer_group=openshift-4.6 __doozer_key=openshift-base-rhel8 __doozer_uuid_tag=base-rhel8-v4.6.0-20250107.204624 __doozer_version=v4.6.0 
ENV __doozer=merge OS_GIT_COMMIT=f020942 OS_GIT_VERSION=4.6.0-202501072046.p0.gf020942.assembly.stream.el8-f020942 SOURCE_DATE_EPOCH=1650510022 SOURCE_GIT_COMMIT=f02094204c5dab97e4ccadd35d135a2ef12c341f SOURCE_GIT_TAG=f0209420 SOURCE_GIT_URL=https://github.com/openshift-eng/ocp-build-data 
# generally we prefer ubi8 as a base for redistributability, but there is no ELS UBI 8.2 stream.
# rhel8-2-els/rhel from rhel-els-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=77439)
# ubi8 from ubi8-container(https://brewweb.engineering.redhat.com/brew/packageinfo?packageID=71187)

RUN echo 'skip_missing_names_on_install=0' >> /etc/yum.conf \
 && yum update -y  \
 && yum clean all

# ubi based images have the ubi repositories available. EUS / ELS images do not have their repositories
# configured, and these repositories are not publicly accessible without an enabled subscription.
# Making ubi8 repo available for all base images for the end user.
COPY ubi.repo /etc/yum.repos.d/ubi.repo

# Start Konflux-specific steps
RUN cp /tmp/yum_temp/* /etc/yum.repos.d/ || true
# End Konflux-specific steps

LABEL \
        name="openshift/base-rhel8" \
        com.redhat.component="openshift-base-rhel8-container" \
        io.openshift.maintainer.project="OCPBUGS" \
        io.openshift.maintainer.component="Release" \
        version="v4.6.0" \
        release="202501072046.p0.gf020942.assembly.stream.el8" \
        io.openshift.build.commit.id="f02094204c5dab97e4ccadd35d135a2ef12c341f" \
        io.openshift.build.source-location="https://github.com/openshift-eng/ocp-build-data" \
        io.openshift.build.commit.url="https://github.com/openshift-eng/ocp-build-data/commit/f02094204c5dab97e4ccadd35d135a2ef12c341f" \
        io.k8s.description="" \
        io.k8s.display-name="" \
        io.openshift.tags="" \
        description="" \
        summary=""


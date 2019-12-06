FROM registry.redhat.io/openshift4/ose-operator-registry:v4.2.1
COPY manifests manifests
RUN /bin/initializer -o ./bundles.db
EXPOSE 50051
ENTRYPOINT ["/bin/registry-server"]
CMD ["--database", "bundles.db"]

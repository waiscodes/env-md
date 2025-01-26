# Role Based Access Control

Generate a key using `openssl`:

```shell
openssl genrsa -out john.key 2048
```

Create a matching certificate signing request for user `john` (`CN=`) belonging to group `group1` (`O=`)

```shell
openssl req -new -key john.key -out john.csr -subj "/CN=john/O=group1"
```

Create a CertificateSigningRequest kubernetes object and apply it

```shell
cat <<EOF | kubectl apply -f -
> apiVersion: certificates.k8s.io/v1
> kind: CertificateSigningRequest
> metadata:
>   name: john
> spec:
>   groups:
>   - system:authenticated
>   request: $(cat john.csr | base64 | tr -d '\n')
>   signerName: kubernetes.io/kube-apiserver-client
>   usages:
>   - client auth
> EOF
```

Our signing request should be available on the cluster and ready to sign, you can confirm its existance by doing

```yaml
kubectl get csr
```

Which should output something along the lines of

```shell
NAME   AGE   SIGNERNAME                            REQUESTOR      CONDITION
john   39s   kubernetes.io/kube-apiserver-client   system:admin   Pending
```

Now we approve the request, causing the server to sign it

```yaml
kubectl certificate approve john
```

Verify our requests has been approved and signed

```yaml
kubectl get csr
```

Retrieve the certificate and store it locally

```yaml
kubectl get csr john -o jsonpath='{.status.certificate}'  | base64 -d > john.crt
```

## Creating the Role

Next we create the role that our user will have, for demonstration purposes im calling my role `john-role`, although any name is possible here as roles can be assigned to multiple groups, users, etc.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: john-role
rules:
    - apiGroups:
          - ""
      resources:
          - pods
      verbs:
          - get
          - list
```

In the above example we are giving the `get` and `list` permissions pertaining to the `pods` resource. Lets apply our role

```yaml
kubectl apply -f role.yml
```

## Creating a RoleBinding

To be able to connect our user and the role it belongs to we create a RoleBinding. The rolebinding should look something like below.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
    name: john-binding
roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: john-role
subjects:
    - apiGroup: rbac.authorization.k8s.io
      kind: User
      name: john
```

Next we apply the role binding.

```yaml
kubectl apply -f rolebinding.yml
```

## Loading the user into your config

Now that we have arrived at the final steps we can load the user into our config using the following command. This will add the credentials, and name them `john` to our `kubeconfig` containing the certificate and keys we just generated and signed.

```yaml
kubectl config set-credentials john --client-key=john.key --client-certificate=john.crt --embed-certs=true
```

All that's left is to create a new context (in this case named it `john` aswell).

```shell
kubectl config set-context john --cluster=default --user=john
```

And voila, you're done. Your newly created user should now have all the permissions you so desire, and be ready to go.

## Setting up local environment

Locally we now have the `john` user account. Lets put it to work. First lets tell kubectl to use the `john` context.

```yaml
kubectl config use-context john
```

You can verify that you have switched contexts by using the following command

```yaml
kubectl config current-context
```

Now lets try and test our permissions.

```yaml
kubectl get pods
```

The above command should have returned a valid output.
Now lets try something we shouldn't be allowed to do. The following should throw a permission denied:

```yaml
kubectl run web-2 --image=nginx
```

## Final

If you've followed all of the above steps correctly you should now have your very own new user account created `john`, and should be able to have access to your cluster.
If you're looking to read more into how and what kubernetes RBAC, don't forget to check [the rbac documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/). In addition to that this post was inspired by [this SO answer](https://stackoverflow.com/a/67336849/17372471)

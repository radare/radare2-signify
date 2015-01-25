radare2-signify
===============

Web of trust for radare2 releases.

It allows to ensure that a given tarball contains what is signed by a developer. The way to protect against man in the middle attacks is to get the public keys from different mediums, preferibly via different communication channels.

I will evaluate more ways to distribute those keys like Twitter, Git, GPG, Website, Packager, ...

If you have r2 installed from your distro, you are trusting it, and therefor if you fetch the build for windows you can verify it, ensuring that the public key is the same in r2 than in the signify repo.

	$ make get-all
	$ make verify-all
	$ make trust-all

You can also do it for a single target:

	$ make android-arm
	$ make osx
	$ make ios
	$ make w32

To become a trusted git you must send a pullreq adding your trusted git url into the master repository. You should create a new signature by editing the OWNER file and typing `make`.

Everytime a new release is done, the maintainers should update their forks against the master repository if needed. But mainly it will require to do `make sign FILE=lalal.tar.gz` to sign that file with your key and push it to your own git repository.

We will slowly add more constrains to make better verifications of the trusted repositories, and we need people wanting to test and verify all the releases and sign them with their keys!

	$ make sign-all

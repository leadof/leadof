# Install the `gh` CLI https://cli.github.com/.

.PHONY: repo
repo:
	@gh repo create leadof/leadof \
		--description "A curated collection of leadership resources." \
		--disable-issues \
		--disable-wiki \
		--public \
		--push \
		--source "../../"

.PHONY: leadof-us
leadof-us:
	@cd ../../../ \
	&& gh repo create leadof/leadof-us \
		--clone \
		--description "The website for leadof.us" \
		--disable-issues \
		--disable-wiki \
		--public \
	&& cd -

.PHONY: leadof-me
leadof-me:
	@cd ../../../ \
	&& gh repo create leadof/leadof-me \
		--clone \
		--description "The website for leadof.me" \
		--disable-issues \
		--disable-wiki \
		--public \
	&& cd -

.PHONY: leadof-tech
leadof-tech:
	@cd ../../../ \
	&& gh repo create leadof/leadof-tech \
		--clone \
		--description "The website for leadof.tech" \
		--disable-issues \
		--disable-wiki \
		--public \
	&& cd -

.PHONY: config
config:
	@gh repo edit leadof/leadof \
		--add-topic "leadership" \
		--delete-branch-on-merge
	@gh repo edit leadof/leadof-us \
		--add-topic "leadership" \
		--delete-branch-on-merge
	@gh repo edit leadof/leadof-me \
		--add-topic "leadership" \
		--delete-branch-on-merge
	@gh repo edit leadof/leadof-tech \
		--add-topic "leadership" \
		--delete-branch-on-merge

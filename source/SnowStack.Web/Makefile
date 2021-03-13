RG_NAME=rg-snowstack
APP_NAME=app-snowstack25692
USER_SECRETS_ID=34877569-5b19-44b8-8baa-147ad148d7c7

.PHONY: deploy
deploy:
	az webapp up --name $(APP_NAME) --sku F1

.PHONY: settings
settings:
	$(eval SNOW_DB:= $(shell cat ~/.microsoft/usersecrets/$(USER_SECRETS_ID)/secrets.json | jq '.[] | .Snowflake'))
	az webapp config connection-string set -g $(RG_NAME) -n $(APP_NAME) -t Custom\
	 --settings Snowflake=$(SNOW_DB)
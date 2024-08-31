

all: build

build:
	@echo "Building Site..."
	@zola build

serve:
	@echo "Running the application..."
	@zola serve


push:
	@echo "Pushing to GitHub..."
	git add .
	@read -p "Enter commit message: " commit_msg; \
	git commit -m "$$commit_msg"; \
	git push
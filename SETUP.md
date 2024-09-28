Here’s a guide to help you setup as you've chosen to contribute to Definomica.

Before you proceed, please read [CONTRIBUTING.md](https://github.com/goodylili/definomica/blob/main/contributing.md) for
the general process of how contributions are handled.

### 1. Install Zola

Follow the installation instructions for your operating system:

 ```bash
    # For macOS
    brew install zola

    # For Ubuntu
    sudo apt install zola

    # For Windows, use the installer from the Zola website
```

Verify the installation by running Zola locally:

```bash
    zola --version
```

### 2. Writing Your Contribution
   Find your way to the [content/posts](https://github.com/goodylili/definomica/tree/main/content/posts) directory and
   create a new Markdown file with the name of the topic you want to write about.

> **Note:**
> - Use a short, informative title.
> - Do not tamper with existing files
> - Add images in the [static/images](https://github.com/goodylili/definomica/tree/main/static/screenshot) directory.


If you’re unfamiliar with Markdown, you can use editors like Notion
to draft your content and paste it into a Markdown file.

### 3. Include Required Metadata Fields

At the top of your Markdown file, include the following fields:

```markdown
    +++
    title = "Your Title Here"
    date = "YYYY-MM-DD"
    author = "Your Name"
    description = "A brief description of the topic"
    +++
```

> **Note:**
> - The title should be a short, informative title.
> - The date should be the date you started writing the article.
> - The author should be your GitHub username.
> - The description should be a short summary of the topic.

### 4. Linting with Markdown Lint

Before submitting, run your Markdown file through a linter to ensure it’s properly formatted:

```bash
    npm install -g markdownlint-cli
    markdownlint yourfile.md
```

Finally, run the following command to check for any errors on a live version of the website:

```bash
zola build
zola serve
```

Open the website running locally and proofread, check for errors or any issues with the document.

### 5. Submitting a Pull Request (PR)

Once you’re satisfied with your changes, submit a PR for review:

```bash
    git add yourfile.md
    git commit -m "Your commit message"
    git push origin your-branch-name
```

Now, you can submit a pull request. Your contribution is appreciated and it will be merged in no distant time. Please
read [CONTRIBUTING.md](https://github.com/goodylili/definomica/blob/main/contributing.md) for
the general process of how contributions are handled.
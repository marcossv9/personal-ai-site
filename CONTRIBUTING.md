# Contributing to personal-ai-site development

Thank you for considering contributing to personal-ai-site! This document outlines some guidelines for contributing to this open source project.

Please make sure to review our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing to personal-ai-site.

There are several ways you can contribute to the betterment of the project:

- **Report an issue?** - If the issue isn’t reported, we can’t fix it. Please report any bugs, feature, and/or improvement requests on the [personal-ai-site GitHub Issues tracker](https://github.com/marcossv9/personal-ai-site/issues).
- **Submit patches** - Do you have a new feature or a fix you'd like to share? [Submit a pull request](https://github.com/marcossv9/personal-ai-site/pulls)!
- **Write blog articles** - Are you using personal-ai-site? We'd love to hear how you're using it with your projects. Write a tutorial and post it on your blog!

## Issues

If you encounter any issues with the project, please check the [existing issues](https://github.com/marcossv9/personal-ai-site/issues) first to see if the issue has already been reported. If the issue hasn't been reported, please open a new issue with a clear description of the problem and steps to reproduce it.

## Pull Requests

Please keep the following guidelines in mind when opening a pull request:

- Provide a clear and detailed description of your changes.
- Keep your changes focused on a single concern.
- Write clean and readable code that follows the project's code style.
- Use descriptive variable and function names.
- Write clear and concise commit messages.
- Add tests for your changes, if possible.
- Ensure that your changes don't break existing functionality.

#### Commit message guidelines

A good commit message should describe what changed and why.


## Development

### 1. Clone the repository
```bash
git clone https://github.com/marcossv9/personal-ai-site.git
cd personal-ai-site
```

### 2. Development Mode (Hot Reload)

Use [`compose.dev.yaml`](compose.dev.yaml) for live code reloading and development features:

```bash
docker compose -f compose.dev.yaml up --build --watch
```
- The app will be available at [http://localhost:8080](http://localhost:8080)
- Any code changes will automatically reload the app (thanks to the `develop` section in `compose.dev.yaml`)
- Ollama may take a few seconds to start; wait for the "Ollama API is ready!" message before sending your first request

### 3. Python Environment

personal-ai-site is written in Python. You should have Python 3.8+ installed on your machine in order to work on personal-ai-site. If that's already setup, run:

```bash
uv sync --locked --no-install-project --no-dev
```
in the root directory to install all dependencies.

### 4. Running Tests

You can run all tests with:

```bash
docker compose -f compose.dev.yaml up --build --watch
```

### 5. Branching and Pull Requests

1. Fork the project repository.
2. Create a new branch for your contribution.
3. Write your code or make the desired changes.
4. Commit your changes and push them to your forked repository.
5. [Open a pull request](https://github.com/marcossv9/personal-ai-site/pulls) to the main project repository with a detailed description of your changes.

## License

personal-ai-site is released under the MIT License. By contributing to this project, you agree to license your contributions under the same license.

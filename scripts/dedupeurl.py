#!/usr/bin/env python3
import argparse
import re
import sys
from urllib.parse import parse_qs, urlencode, urlparse, urlunparse


def get_unique_url_structures(urls):
    """
    Analyzes a list of URLs and returns a sorted list of unique URL structures.
    This version now also generalizes URLs for dynamically generated JS/CSS files.
    """
    unique_structures = set()
    processed_structures = set()

    # Regex to find JS/CSS files with generated hashes in their names
    # e.g., /js/js_RANDOMSTRING.js or /css/css_RANDOMSTRING.css
    asset_regex = re.compile(r"/(js|css)/([a-zA-Z]{2}_)[\w-]+\.(js|css)$")

    for url in urls:
        original_url = url
        try:
            # First, check if the URL path matches the asset pattern and generalize it
            parsed_for_path = urlparse(url)
            match = asset_regex.search(parsed_for_path.path)
            if match:
                # Replace the hashed filename with a placeholder
                # e.g., /js/js_....js -> /js/js_[HASH].js
                placeholder_path = asset_regex.sub(
                    f"/{match.group(1)}/{match.group(2)}[HASH].{match.group(3)}",
                    parsed_for_path.path,
                )
                url = urlunparse(
                    (
                        parsed_for_path.scheme,
                        parsed_for_path.netloc,
                        placeholder_path,
                        parsed_for_path.params,
                        parsed_for_path.query,
                        parsed_for_path.fragment,
                    )
                )

            # Continue with the existing logic to parse the (now possibly generalized) URL
            parsed_url = urlparse(url)
            query_params = parse_qs(parsed_url.query, keep_blank_values=True)

            # Generalize parameter values that are just numbers
            for key, values in query_params.items():
                new_values = []
                for val in sorted(values):
                    if val.isdigit():
                        new_values.append("[NUMBER]")
                    else:
                        new_values.append(val)
                query_params[key] = tuple(new_values)

            # Create a representative structure: base URL + sorted parameter keys
            param_structure = tuple(sorted(query_params.keys()))

            # Use the generalized path and param structure to identify unique URLs
            structure_key = (
                parsed_url.scheme,
                parsed_url.netloc,
                parsed_url.path,
                param_structure,
            )

            if structure_key not in processed_structures:
                processed_structures.add(structure_key)
                # Reconstruct a clean, representative URL for display
                representative_query = urlencode(
                    [(key, "") for key in sorted(query_params.keys())]
                )
                representative_url = urlunparse(
                    (
                        parsed_url.scheme,
                        parsed_url.netloc,
                        parsed_url.path,
                        "",
                        representative_query,
                        "",
                    )
                )
                unique_structures.add(representative_url)

        except Exception as e:
            # Print errors to standard error without cluttering the output
            print(f"Could not parse URL: {original_url} - Error: {e}", file=sys.stderr)
            continue

    return sorted(list(unique_structures))


def main():
    """
    Main function to handle command-line arguments and run the tool.
    """
    parser = argparse.ArgumentParser(
        description="Sorts and filters URLs to find unique structures, generalizing numeric parameters and hashed asset filenames.",
        epilog="Example: python url_sorter.py gf_xss.txt -o unique_urls.txt",
    )
    parser.add_argument(
        "input_file",
        help="The path to the input text file containing URLs, one per line.",
    )
    parser.add_argument(
        "-o",
        "--output",
        help="The path to an output file to save the results. If not provided, results are printed to the console.",
        metavar="output_file",
    )

    args = parser.parse_args()

    try:
        with open(args.input_file, "r") as f:
            urls_from_file = [line.strip() for line in f.readlines() if line.strip()]
    except FileNotFoundError:
        print(f"Error: Input file not found at '{args.input_file}'", file=sys.stderr)
        sys.exit(1)

    unique_url_list = get_unique_url_structures(urls_from_file)

    if args.output:
        try:
            with open(args.output, "w") as f:
                for url in unique_url_list:
                    f.write(url + "\n")
            print(f"Successfully processed {len(urls_from_file)} URLs.")
            print(
                f"Found {len(unique_url_list)} unique URL structures. Results saved to '{args.output}'"
            )
        except IOError as e:
            print(
                f"Error: Could not write to the output file '{args.output}'. {e}",
                file=sys.stderr,
            )
            sys.exit(1)
    else:
        for url in unique_url_list:
            print(url)


if __name__ == "__main__":
    main()

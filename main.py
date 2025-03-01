#!/usr/bin/env python3

import argparse
import torch

def main(args: argparse.Namespace) -> None:
    # Test PyTorch installation
    print("PyTorch version:", torch.__version__)

    # Create a tensor and perform a simple arithmetic operation
    x: torch.Tensor = torch.tensor([1.0, 2.0, 3.0])
    y: torch.Tensor = x * 2
    print("Input tensor:", x)
    print("Result tensor (x * 2):", y)

    # If the --plot flag is provided, display a plot using matplotlib and seaborn
    if args.plot:
        import matplotlib.pyplot as plt
        import seaborn as sns
        import numpy as np

        # Set a seaborn style for the plot
        sns.set(style="darkgrid")

        # Create some data for plotting: a sine wave
        x_vals = np.linspace(0, 10, 100)
        y_vals = np.sin(x_vals)

        plt.plot(x_vals, y_vals, label="sin(x)")
        plt.title("Sine Wave")
        plt.xlabel("x")
        plt.ylabel("sin(x)")
        plt.legend()

        # Show the plot in a window; close the window to continue/exit the script
        plt.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Test PyTorch and optionally display a plot using matplotlib and seaborn."
    )
    parser.add_argument(
        "--plot",
        action="store_true",
        help="If set, open a window to display a matplotlib/seaborn plot."
    )
    args = parser.parse_args()
    main(args)

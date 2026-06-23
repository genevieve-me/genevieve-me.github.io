"""Most basic neural net - train to approximate a one dimensional function with n hidden features."""

import torch
import torch.nn as torch_nn
import torch.optim as torch_optim
import numpy as np
import matplotlib.pyplot as plt

x_train = torch.unsqueeze(torch.linspace(-2 * np.pi, 2 * np.pi, 2000), dim=1)
y_train = torch.sin(x_train)


class SineApprox(torch_nn.Module):
    def __init__(self):
        super().__init__()
        self.hidden1 = torch_nn.Linear(1, 50)  # 1 input, 50 hidden features
        self.hidden2 = torch_nn.Linear(50, 50)  # layer 2 (depth)
        self.output = torch_nn.Linear(50, 1)  # 1 output
        self.activation = torch_nn.Tanh()

    def forward(self, x):
        """Pass x through layers with activation after each layer except final output layer."""
        x = self.activation(self.hidden1(x))
        x = self.activation(self.hidden2(x))
        x = self.output(x)
        return x


if __name__ == "__main__":
    model = SineApprox()
    criterion = torch_nn.MSELoss()
    optimizer = torch_optim.Adam(model.parameters(), lr=3e-4)

    epochs = 2000

    for epoch in range(2000):
        # forward pass, compute loss, clear previous step's gradients, backward pass, update learned weights
        pred = model(x_train)
        loss = criterion(pred, y_train)
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        if (epoch + 1) % 200 == 0:
            print(f"Epoch [{epoch + 1}/{epochs}], Loss: {loss.item():.4f}")

    # Generate predictions for the final plot
    with torch.no_grad():
        predicted = model(x_train).numpy()

    plt.figure(figsize=(10, 6))
    plt.title("Neural Network approximation of Sin(x)")
    plt.plot(x_train, y_train, label="True Sine Function", color="blue", alpha=0.5)
    plt.plot(
        x_train,
        predicted,
        label="Neural Network Prediction",
        color="red",
        linestyle="--",
    )
    plt.legend()
    plt.show()

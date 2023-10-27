using Godot;
using System;

public partial class main : Node2D
{
    public override void _Ready()
    {
        GD.Print("Hello jam");
        GetTree().Quit();
    }


}

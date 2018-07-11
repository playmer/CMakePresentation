#include <iostream>

#include <GLFW/glfw3.h>

int myLibsVeryImportantFunction()
{
    // we C++ we gotta use the features!
    try
    {
        std::cout << "Woo this important function!";

        // now lets zip ourselves, that sounds pretty fun!
        
        GLFWwindow* window;

        /* Initialize the library */
        if (!glfwInit())
            return -1;

        /* Create a windowed mode window and its OpenGL context */
        window = glfwCreateWindow(640, 480, "Hello World", NULL, NULL);
        if (!window)
        {
            glfwTerminate();
            return -1;
        }

        /* Make the window's context current */
        glfwMakeContextCurrent(window);

        /* Loop until the user closes the window */
        while (!glfwWindowShouldClose(window))
        {
            /* Swap front and back buffers */
            glfwSwapBuffers(window);

            /* Poll for and process events */
            glfwPollEvents();
        }

        glfwTerminate();

        return 0;
    }
    catch(...)
    {
        return 1;
    }
}
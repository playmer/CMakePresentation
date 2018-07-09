#include <iostream>

int myLibsVeryImportantFunction()
{
    try
    {
        std::cout << "Woo this important function!";
        return 0;
    }
    catch(...)
    {
        return 1;
    }
}
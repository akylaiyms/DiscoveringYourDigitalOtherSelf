using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSwitch : MonoBehaviour
{
    public GameObject camera1;
    public GameObject camera2;
    public GameObject camera3;
    public GameObject camera4;
    public GameObject camera5;

    void Update()
    {
        if(Input.GetButtonDown("RKey"))
        {
            camera1.SetActive(true);
            camera2.SetActive(false);
            camera3.SetActive(false);
            camera4.SetActive(false);
            camera5.SetActive(false);
        }

        if(Input.GetButtonDown("LKey"))
        {
            camera1.SetActive(false);
            camera2.SetActive(true);
            camera3.SetActive(false);
            camera4.SetActive(false);
            camera5.SetActive(false);
        }

        if(Input.GetButtonDown("UKey"))
        {
            camera1.SetActive(false);
            camera2.SetActive(false);
            camera3.SetActive(true);
            camera4.SetActive(false);
            camera5.SetActive(false);
        }

        if(Input.GetButtonDown("DKey"))
        {
            camera1.SetActive(false);
            camera2.SetActive(false);
            camera3.SetActive(false);
            camera4.SetActive(true);
            camera5.SetActive(false);
        }

        if(Input.GetButtonDown("SpaceKey"))
        {
            camera1.SetActive(false);
            camera2.SetActive(false);
            camera3.SetActive(false);
            camera4.SetActive(false);
            camera5.SetActive(true);
        }
    }
}

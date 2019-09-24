using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GrateControl : MonoBehaviour {

    public static float THRESHOLD = 0.8f;
    public static int LEVELS = 5;

    public int horizontalIndex = LEVELS;
    public int radialIndex = LEVELS;

    public Slider horizontalSlider;
    public Slider radialSlider;
    private Material mat;
    private bool on = true;
    private OVRInput.Controller controller;

    private void Start() {
        mat = GetComponent<Renderer>().material;
        controller = OVRInput.Controller.RTrackedRemote;
    }

    void Update () {
        // Trigger
        if (OVRInput.GetDown(OVRInput.Button.PrimaryIndexTrigger, controller) || Input.GetKeyDown(KeyCode.Space)) {
            on = !on;
            if (on) {
                mat.SetInt("_On", 1);
            } else {
                mat.SetInt("_On", 0);
            }
        }

        // Touchpad
        if (OVRInput.GetDown(OVRInput.Button.DpadDown, controller) || Input.GetKeyDown(KeyCode.RightArrow)) {
            radialIndex = Mathf.Min(radialIndex + 1, LEVELS);
        }
        else if (OVRInput.GetDown(OVRInput.Button.DpadUp, controller) || Input.GetKeyDown(KeyCode.LeftArrow)) {
            radialIndex = Mathf.Max(radialIndex - 1, 0);
        }
        else if (OVRInput.GetDown(OVRInput.Button.DpadLeft, controller) || Input.GetKeyDown(KeyCode.UpArrow)) {
            horizontalIndex = Mathf.Min(horizontalIndex + 1, LEVELS);
        }
        else if (OVRInput.GetDown(OVRInput.Button.DpadRight, controller) || Input.GetKeyDown(KeyCode.DownArrow)) {
            horizontalIndex = Mathf.Max(horizontalIndex - 1, 0);
        }

        /*Vector2 vec = OVRInput.Get(OVRInput.Axis2D.PrimaryTouchpad, OVRInput.Controller.RTrackedRemote);
        if (vec.x > THRESHOLD || Input.GetKeyDown(KeyCode.RightArrow)) {
            radialIndex = Mathf.Min(radialIndex + 1, LEVELS);
        } else if (vec.x < -THRESHOLD || Input.GetKeyDown(KeyCode.LeftArrow)) {
            radialIndex = Mathf.Max(radialIndex - 1, 0);
        } else if (vec.y > THRESHOLD || Input.GetKeyDown(KeyCode.UpArrow)) {
            horizontalIndex = Mathf.Min(horizontalIndex + 1, LEVELS);
        } else if (vec.y < -THRESHOLD || Input.GetKeyDown(KeyCode.DownArrow)) {
            horizontalIndex = Mathf.Max(horizontalIndex - 1, 0);
        }*/

        // Sliders
        horizontalSlider.value = horizontalIndex;
        radialSlider.value = radialIndex;

        // Set contrasts
        float deviationRadial = 1.0f * radialIndex / LEVELS / 2;
        mat.SetColor("_DarkRadial", new Color(0.5f + deviationRadial, 0.5f + deviationRadial, 0.5f + deviationRadial));
        mat.SetColor("_LightRadial", new Color(0.5f - deviationRadial, 0.5f - deviationRadial, 0.5f - deviationRadial));
        float deviationHorizontal = 1.0f * horizontalIndex / LEVELS / 2;
        mat.SetColor("_DarkHorizontal", new Color(0.5f + deviationHorizontal, 0.5f + deviationHorizontal, 0.5f + deviationHorizontal));
        mat.SetColor("_LightHorizontal", new Color(0.5f - deviationHorizontal, 0.5f - deviationHorizontal, 0.5f - deviationHorizontal));
    }

    private void OnWillRenderObject() {
        if (Camera.current.name.Equals("LeftEyeAnchor")) {
            if (on) {
                Shader.SetGlobalInt("RenderingEye", 0);
            } else {
                Shader.SetGlobalInt("RenderingEye", 1);
            }
        } else if (Camera.current.name.Equals("RightEyeAnchor")) {
            Shader.SetGlobalInt("RenderingEye", 1);
        }
    }
}

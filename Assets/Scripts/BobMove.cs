using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BobMove : MonoBehaviour
{
    public float distance = 0.5f;
    public float speed = 10f;

    void FixedUpdate()
    {
        Bob();
    }

    private void Bob()
    {
        Vector3 tempVector = transform.position;
        tempVector.y = distance * Mathf.Sin(Time.frameCount * Time.fixedDeltaTime * speed);
        Debug.Log(tempVector);
        transform.position = tempVector;
    }
}

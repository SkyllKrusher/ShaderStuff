using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BobMove : MonoBehaviour
{
    public float distance = 0.5f;
    public float speed = 10f;
    private int tick = 0;

    void FixedUpdate()
    {
        Bob();
    }

    private void Bob()
    {
        Vector3 tempVector = transform.position;
        float perFrameMove = tick * Time.fixedDeltaTime;
        tempVector.y = distance * Mathf.Sin(perFrameMove * speed / 100 * Mathf.Rad2Deg);
        // Debug.Log(tempVector);
        transform.position = tempVector;
        tick++;
    }
}

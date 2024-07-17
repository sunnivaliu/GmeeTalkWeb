using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlassWithMan : MonoBehaviour
{
    public GameObject ArmyAvatar;
    public GameObject glass;

    private Vector3 PosDiff;
    private Quaternion RotDiff;
    private Vector3 PrevPosHead;
    private Quaternion PrevRotHead;
    private Vector3 PrevPosGlass;
    private Quaternion PrevRotGlass;

    void Start()
    {
        PrevPosHead = ArmyAvatar.transform.position;
        PrevRotHead = ArmyAvatar.transform.rotation;
        PrevPosGlass = glass.transform.position;
        PrevRotGlass = glass.transform.rotation;
    }


    void Update()
    {
        PosDiff = ArmyAvatar.transform.position - PrevPosHead;
        RotDiff = ArmyAvatar.transform.rotation * Quaternion.Inverse(PrevRotHead);
        glass.transform.position = PrevPosGlass + PosDiff;
        glass.transform.rotation = RotDiff * PrevRotGlass;
        PrevPosHead = ArmyAvatar.transform.position;
        PrevRotHead = ArmyAvatar.transform.rotation;
        PrevPosGlass = glass.transform.position;
        PrevRotGlass = glass.transform.rotation;
    }
}

using System;
using UnityEngine;

public class Vertex : MonoBehaviour
{
    public Material material;

    //CPU�ڴ�
    Vector3[] verts;

    //GPU����
    ComputeBuffer Buffer;

    void OnEnable()
    {
        //�����ڴ�
        verts = new Vector3[3] 
        {
            new Vector3(-0.5f, -0.5f, 0),
            new Vector3( 0.5f, -0.5f, 0),
            new Vector3( 0.0f,  0.5f, 0),
        };

        //����GPU����
        Buffer = new ComputeBuffer(verts.Length, sizeof(float) * 3);

        //��CPU�ڴ����ݴ��䵽GPU����
        Buffer.SetData(verts);

        //���ò��ʵĶ��㻺����
        material.SetBuffer("_Vertices", Buffer);
    }

    void OnDisable()
    {
        Buffer?.Release();
    }

    void OnRenderObject()
    {
        material.SetPass(0);
        Graphics.DrawProceduralNow(MeshTopology.Points, Buffer.count);
    }
}

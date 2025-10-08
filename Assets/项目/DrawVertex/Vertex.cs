using System;
using UnityEngine;

public class Vertex : MonoBehaviour
{
    public Material material;

    //CPU内存
    Vector3[] verts;

    //GPU缓存
    ComputeBuffer Buffer;

    void OnEnable()
    {
        //创建内存
        verts = new Vector3[3] 
        {
            new Vector3(-0.5f, -0.5f, 0),
            new Vector3( 0.5f, -0.5f, 0),
            new Vector3( 0.0f,  0.5f, 0),
        };

        //创建GPU缓存
        Buffer = new ComputeBuffer(verts.Length, sizeof(float) * 3);

        //将CPU内存数据传输到GPU缓存
        Buffer.SetData(verts);

        //设置材质的顶点缓冲区
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

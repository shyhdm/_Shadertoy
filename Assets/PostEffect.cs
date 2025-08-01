using UnityEngine;

[ExecuteInEditMode]
public class PostEffect : MonoBehaviour
{
    public Material PostEffectMat;

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, PostEffectMat);
    }
}
